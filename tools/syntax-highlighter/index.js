/*! Highlight.js 11.12.0 | BSD-3-Clause | shared/theme/vendor/highlight-LICENSE.txt */
/* Offline mdBook highlighter. The committed bundle is shared by all books.
 * Register grammars before book.js runs, through mdBook's theme/highlight.js hook.
 */
import hljs from 'highlight.js/lib/core';
import bash from 'highlight.js/lib/languages/bash';
import c from 'highlight.js/lib/languages/c';
import cpp from 'highlight.js/lib/languages/cpp';
import python from 'highlight.js/lib/languages/python';
import rust from 'highlight.js/lib/languages/rust';
import javascript from 'highlight.js/lib/languages/javascript';
import json from 'highlight.js/lib/languages/json';
import sql from 'highlight.js/lib/languages/sql';
import x86asm from 'highlight.js/lib/languages/x86asm';
import armasm from 'highlight.js/lib/languages/armasm';
import llvm from 'highlight.js/lib/languages/llvm';
import ini from 'highlight.js/lib/languages/ini';
import makefile from 'highlight.js/lib/languages/makefile';
import http from 'highlight.js/lib/languages/http';
import yaml from 'highlight.js/lib/languages/yaml';
import markdown from 'highlight.js/lib/languages/markdown';
import lua from 'highlight.js/lib/languages/lua';
import awk from 'highlight.js/lib/languages/awk';
import cmake from 'highlight.js/lib/languages/cmake';
import dockerfile from 'highlight.js/lib/languages/dockerfile';
import vim from 'highlight.js/lib/languages/vim';
import protobuf from 'highlight.js/lib/languages/protobuf';
import xml from 'highlight.js/lib/languages/xml';
import powershell from 'highlight.js/lib/languages/powershell';
import plaintext from 'highlight.js/lib/languages/plaintext';

const languages = { bash, c, cpp, python, rust, javascript, json, sql, x86asm, armasm, llvm, ini, makefile, http, yaml, markdown, lua, awk, cmake, dockerfile, vim, protobuf, xml, powershell, plaintext };
for (const [name, grammar] of Object.entries(languages)) hljs.registerLanguage(name, grammar);
hljs.registerAliases(['asm'], { languageName: 'x86asm' });
hljs.registerAliases(['jsonl'], { languageName: 'json' });
hljs.registerAliases(['bats'], { languageName: 'bash' });
// Keep unsupported domain-specific formats explicit, readable and free of guessing.
hljs.registerAliases(['promql', 'cron', 'sudoers', 'hcl', 'rego', 'cedar', 'kconfig', 'gdb', 'dts', 'ld', 'sshconfig'], { languageName: 'plaintext' });
// mdBook 0.5 calls this legacy entry point; preserve it without deprecation logs.
hljs.highlightBlock = element => hljs.highlightElement(element);
window.hljs = hljs;
