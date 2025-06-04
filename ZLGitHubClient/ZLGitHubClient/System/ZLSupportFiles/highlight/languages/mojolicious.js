/*! `mojolicious` grammar compiled for Highlight.js 11.11.1 */
  (function(){
    var hljsGrammar = (function () {
  'use strict';

  /*
  Language: Mojolicious
  Requires: xml.js, perl.js
  Author: Dotan Dimet <dotan@corky.net>
  Description: Mojolicious .ep (Embedded Perl) templates
  Website: https://mojolicious.org
  Category: template
  */
  function mojolicious(hljs) {
    return {
      name: 'Mojolicious',
      subLanguage: 'xml',
      contains: [
        {
          className: 'meta',
          begin: '^__(END|DATA)__$'
        },
        // mojolicious line
        {
          begin: "^\\s*%{1,2}={0,2}",
          end: '$',
          subLanguage: 'perl'
        },
        // mojolicious block
        {
          begin: "<%{1,2}={0,2}",
          end: "={0,1}%>",
          subLanguage: 'perl',
          excludeBegin: true,
          excludeEnd: true
        }
      ]
    };
  }

  return mojolicious;

})();

    hljs.registerLanguage('mojolicious', hljsGrammar);
  })();