"""Regressions for site navigation and semantic section boundaries."""
import tempfile
import unittest
from pathlib import Path

from check_book_boundaries import check_content
from check_site_links import audit


class SiteLinkTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)

    def write(self, name, content):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding='utf-8')

    def test_relative_cross_book_project_urls_and_directory_indices(self):
        self.write('a/deep/page.html', '''<a href="../../b/?q=1#target">relative</a>
<a href="/tutorials/b/#target">root</a>
<a href="https://juanwang-buaa.github.io/tutorials/b/#target">absolute</a>
<a href="//juanwang-buaa.github.io/tutorials/b/#target">protocol relative</a>
<a href="/tutorials">home</a>''')
        self.write('b/index.html', '<h2 id="target">Target</h2>')
        self.write('index.html', 'Home')
        result = audit(self.root)
        self.assertEqual(result['checked_links'], 5)
        self.assertEqual(result['broken_links'], [])

    def test_missing_file_fragment_and_escape_are_reported_at_source_line(self):
        self.write('a/page.html', '<a href="missing.html">404</a>\n<a href="#absent">fragment</a>\n<a href="../../outside.html">escape</a>')
        result = audit(self.root)
        self.assertEqual([(error['line'], error['reason']) for error in result['broken_links']],
                         [(1, 'missing_file'), (2, 'missing_anchor'), (3, 'outside_site')])

    def test_encoded_fragments_named_anchors_text_fragments_and_downloads(self):
        self.write('index.html', '''<h2 id="中文">Heading</h2><a name="legacy"></a>
<a href="#%E4%B8%AD%E6%96%87">encoded</a><a href="#legacy">named</a>
<a href="#:~:text=excerpt">text</a><a href="#中文:~:text=excerpt">both</a>
<area href="notes%20one.pdf#page=2"><a href="?q=search#legacy">query</a>''')
        self.write('notes one.pdf', 'test download')
        result = audit(self.root)
        self.assertEqual(result['checked_links'], 6)
        self.assertEqual(result['broken_links'], [])

    def test_external_links_and_code_samples_are_not_local_navigation(self):
        self.write('index.html', '''<a href="https://example.com/missing">external</a>
<a href="mailto:reader@example.com">email</a><a href="/another-project/">elsewhere</a>
<a href="https://juanwang-buaa.github.io/another-project/">same host</a>
<pre>&lt;a href="missing.html"&gt;</pre>''')
        result = audit(self.root)
        self.assertEqual(result['checked_links'], 0)
        self.assertEqual(result['broken_links'], [])

    def test_print_pages_and_absolute_links_on_404_are_checked(self):
        self.write('print.html', '<a href="#absent">broken</a>')
        self.write('404.html', '<a href="index.html">unknown depth</a><a href="/tutorials/missing.html">broken absolute</a>')
        result = audit(self.root)
        self.assertEqual(result['checked_links'], 2)
        self.assertEqual(len(result['broken_links']), 2)

    def test_empty_site_is_visible_to_the_gate(self):
        self.assertEqual(audit(self.root)['pages'], 0)


class BookBoundaryTests(unittest.TestCase):
    def test_balanced_box_that_swallows_a_section_is_rejected(self):
        errors = check_content('::: ex Example\n::: proof Solution\nAnswer\n:::\n## Next section\n:::')
        self.assertEqual(errors, [{'line': 5, 'reason': 'section_inside_box', 'box_line': 1}])

    def test_nested_boxes_closed_before_the_next_section_pass(self):
        self.assertEqual(check_content('::: ex Example\n::: proof Solution\n### Local detail\n:::\n:::\n## Next section'), [])

    def test_fences_preserve_literal_headings_boxes_and_shorter_fences(self):
        self.assertEqual(check_content('::: ex Example\n````markdown\n```\n## Literal\n::: example\n````\n~~~text\n# Literal\n~~~\n:::\n## Next'), [])

    def test_missing_and_extra_closes_are_rejected(self):
        self.assertEqual(check_content(':::\n::: ex Example'), [
            {'line': 1, 'reason': 'unexpected_box_close'},
            {'line': 2, 'reason': 'unclosed_box'},
        ])


if __name__ == '__main__':
    unittest.main()
