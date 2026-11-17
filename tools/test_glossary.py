"""Consumer-visible glossary matching regressions."""
import json
import tempfile
import unittest
from pathlib import Path

from build_glossary import build


class NumericalGlossaryTests(unittest.TestCase):
    def test_compound_names_and_aliases_remain_whole(self):
        with tempfile.TemporaryDirectory() as tmp:
            book = Path(tmp) / 'numerical'
            page = book / 'book' / 'review' / 'glossary.html'
            page.parent.mkdir(parents=True)
            page.write_text('''<h2 id="terms">术语</h2><table>
<tr><th>中文</th><th>English</th><th>一句话</th><th>出处</th></tr>
<tr><td>Jacobi 迭代</td><td>Jacobi iteration</td><td>说明</td><td><a href="../course/jacobi.html#definition">正文</a></td></tr>
<tr><td>Gauss–Seidel 迭代</td><td>Gauss–Seidel iteration</td><td>说明</td><td><a href="../course/gs.html#definition">正文</a></td></tr>
<tr><td>截断误差 / 方法误差</td><td>truncation error</td><td>说明</td><td><a href="../course/error.html#definition">正文</a></td></tr>
</table>''', encoding='utf-8')
            self.assertEqual(build(str(book)), 0)
            data = json.loads((book / 'book' / 'glossary.json').read_text(encoding='utf-8'))
            aliases = {name for entry in data['terms'] for name in entry['terms']}
            self.assertTrue({'Jacobi 迭代', 'Gauss–Seidel 迭代', '截断误差', '方法误差'} <= aliases)
            self.assertFalse({'迭代', 'Jacobi', 'Gauss', 'Seidel'} & aliases)
            targets = {entry['terms'][0]: entry['href'] for entry in data['terms']}
            self.assertEqual(targets['Gauss–Seidel 迭代'], 'course/gs.html#definition')


if __name__ == '__main__':
    unittest.main()
