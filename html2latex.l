%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// List type represents the current list (OL or UL) for the LI element
int list_type;
%}

%option       noyywrap nounput yylineno
%x            COMMENT PARA PRE OL UL LI

%%

"<h1>"[^<]*"</h1>" {
    /**************************************************************************
     * Matched an HTML H1 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\section{%s}", yytext+4 );
}

"<h2>"[^<]*"</h2>" {
    /**************************************************************************
     * Matched an HTML H2 header so print it out as a LateX subsection title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsection{%s}", yytext+4 );
}

"<h3>"[^<]*"</h3>" {
    /**************************************************************************
     * Matched an HTML H3 header so print it out as a LateX subsubsection title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsubsection{%s}", yytext+4 );
}

"<!--" {
    /**************************************************************************
     * Matched an HTML comment so print it out as a LateX comment. The
     * beginning and ending tags are stripped off before the LateX comment
     * is emitted.
     *************************************************************************/
    printf( "%% " );
    BEGIN COMMENT;
}

[ \t\n\r]+ {
    /**************************************************************************
     * Matched some whitespace that is not inside of an HTML tag. We
     * just ignore the whitespace.
     *************************************************************************/
}

. {
    /**************************************************************************
     * Matched something that we did not expect to see. Issue an error and
     * exit the program with a failure code.
     *************************************************************************/
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}

<COMMENT>"-->" {
    /**************************************************************************
     * Matched an HTML end comment while parsing an HTML comment. Print out
     * a new line and resume normal parsing.
     *************************************************************************/
    printf( "\n" );
    BEGIN 0;
}

<COMMENT>[\n](\r)? {
    /**************************************************************************
     * Matched a newline while parsing an HTML comment. Print out a new
     * line making sure to mark the next line as a comment as well.
     *************************************************************************/
    printf( "\n%% " );
}

<COMMENT>[ \t] {
    /**************************************************************************
     * Matched some white space while parsing an HTML comment. Print out
     * the white space as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<COMMENT>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML comment. Print out
     * the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}


"<pre>" {
  /*****************************************************************************
   * Match the <pre> tag in the HTML. It will print and BEGIN the LaTeX verbatim
   * element.
   *****************************************************************************/
  printf( "\\begin{verbatim}");
  BEGIN PRE;
}
<PRE>. {
  /**************************************************************************
   * Print out all of the text within the <pre> HTML element 
   * (or verbatim in this case) 
   *************************************************************************/
  printf("%s", yytext);
}
<PRE>"</pre>" {
  /**************************************************************************
   * Match and end the </pre> HTLM element and convert to end the LaTeX
   * verbatim element. It will then jump out of the Lex PRE and BEGIN 0
   *************************************************************************/
  printf("\\end{verbatim}\n");
  BEGIN 0;
}


"<p>" {
  /**************************************************************************
   * Matches the <p> HTML element and begins the Lex PARA
   *************************************************************************/
  BEGIN PARA;
}
<PARA>"<small>"[^<]*"</small>" {
  /**************************************************************************
   * Support for the HTML <small> element within a paragraph. 
   * Will convert the <small> element, along with all text within it, to the
   * LaTeX equivalent (scriptsize). 
   *************************************************************************/
  
  // Stip off the </small> tag from the end and output starting after the <small> tag
  yytext[yyleng-8] = 0;
  printf("{\\scriptsize %s}", yytext + 7);
}

<PARA>"<big>"[^<]*"</big>" {
    /***********************************************************************
     * Support for the HTML <big> element within a paragraph. 
     * Will convert the <big> element, along with all text within it, to the
     * LaTeX equivalent
     ***********************************************************************/
  yytext[yyleng - 6] = 0;
  printf("{\\Large %s}", yytext + 5);
}

<PARA>"<b>"[^<]*"</b>" {
  /**************************************************************************
   * Support for the HTML <b> tag within a paragraph. 
   * Will convert the <b> element, along with any text within into the 
   * LaTeX equivalent \textbf{}
   *************************************************************************/
  yytext[yyleng-4] = 0;
  printf("\\textbf{%s}", yytext + 3);
}

<PARA>"<i>"[^<]*"</i>" {
  /**************************************************************************
   * Support for the HTML <i> tag within a paragraph.
   * Will convert the <i> elements, along with all text, into the LaTeX
   * equivalent \textit{}
   *************************************************************************/
  yytext[yyleng - 4] = 0; 
  printf("\\textit{%s}", yytext + 3);
}

<PARA>"<strong>"[^<]*"</strong>" {
  /**************************************************************************
   * Support for the HTML <strong> tag within a paragraph.  
   * Will convert the <strong> element, along with all text within, into the 
   * LaTeX equivalent,\textmd{}
   *************************************************************************/
  yytext[yyleng - 9] = 0;
  printf("\\textmd{%s}", yytext + 8);
}

<PARA>"<em>"[^<]*"</em>" {
  /**************************************************************************
   * Support for the HTML tag <em> within a paragraph.
   * Will convert the <em> tag, and all text within, to its LaTeX equivalent
   * \emph{}.
   *************************************************************************/
  yytext[yyleng - 5] = 0;
  printf("\\emph{%s}", yytext + 4);
}

<PARA>"<sup>"[^<]*"</sup>" {
  /**************************************************************************
   * Support for the HTML tag <sup> within a paragraph. 
   * Will convert the <sup> tag, and all text within, into it's LaTeX
   * equivalent \textsuperscript{}.
   *************************************************************************/
  yytext[yyleng - 6] = 0;
  printf("\\textsuperscript{%s}", yytext + 5);
}

<PARA>"<sub>"[^<]*"</sub>" {
  /**************************************************************************
   * Support for the HTML tag <sub> within a paragraph. 
   * Will convert the <sub> tag, along with all text within it, to the LaTeX
   * equivalent \textsubscript{} 
   *************************************************************************/
  yytext[yyleng - 6] = 0; 
  printf("\\textsubscript{%s}", yytext + 5);
}
<PARA>"</p>" {
  /**************************************************************************
   * Detects the end of the HTML paragraph </p>. In this case, to match LaTeX,
   * it will just print two new lines. 
   *************************************************************************/
  printf("\n\n");
  BEGIN 0;
}



"<ol>" {
  /**************************************************************************
   * Support for the HTML tag <ol>. In this case, it will convert it to its 
   * LaTeX equivalent, \begin{enumerate} and then BEGIN OL. Within OL, it
   * supports the nesting of other HTML elements.
   *************************************************************************/
  printf("\\begin{enumerate}");
  BEGIN OL;
}

<OL>"</ol>" {
  /**************************************************************************
   * Support to match the end of the <ol> element, </ol>. This will convert
   * it to its LaTeX equivalent, ending the enumerate and calling BEGIN 0.
   *************************************************************************/
  printf("\\end{enumerate}\n");
  BEGIN 0;
}

<OL>"<li>" {
  /**************************************************************************
   * Support to match the HTML element <li> within the ordered list element. 
   * This will go ahead and convert the <li> tag to its LaTeX equivalent 
   * \item, and BEGIN LI, since LI can also nest other elements. 
   * 
   * Additionally, it sets the list_type variable to 1, indicating that any 
   * list item within will belong to this parent <ol>. 
   *************************************************************************/
  list_type = 1;
  printf("\\item ");
  BEGIN LI;
}

"<ul>" {
  /**************************************************************************
   * Support for the HTML element <ul>. In this case, it will convert it to
   * its LaTeX equivalent, \being{itemize}, and then BEGIN UL. Within UL, it
   * supports the nesting of other HTML elements.
   *************************************************************************/
  printf("\\begin{itemize}");
  BEGIN UL;
}

<UL>"</ul>" {
  /**************************************************************************
   * Support to match the end of the <ul> element, </ul>. This will convert 
   * it to its LaTeX equivalent, ending the itemize and calling BEGIN 0.
   *************************************************************************/
  printf("\\end{itemize}\n");
  BEGIN 0;
}

<UL>"<li>" {
  /**************************************************************************
   * Support to match the HTML element <li> within the unordered list element. 
   * This will go ahead and convert the <li> tag to its LaTeX equivalent 
   * \item, and BEGIN LI, since LI can also nest other elements. 
   * Additionally, it sets the list_type variable to 2, indicating that any 
   * list item within will belong to this parent <ul>. 
   *************************************************************************/
  list_type = 2;
  printf("\\item ");
  BEGIN LI;
}

<LI>"<small>"[^>]*"</small>" {
  /**************************************************************************
   * Support for the HTML element <small> within the list element. 
   * It will convert the <small> tag, along with all text within, into its 
   * LaTeX equivalent \scriptsize. 
   *************************************************************************/
  yytext[yyleng-8] = 0;
  printf("{\\scriptsize %s}", yytext + 7);
}

<LI>"<big>"[^>]*"</big>" {
  /**************************************************************************
   * Support for the HTML element <big> within the list element. 
   * It will convert the <big> tag, along with all text within, into its 
   * LaTeX equivalent \Large.
   *************************************************************************/
  yytext[yyleng - 6] = 0;
  printf("{\\Large %s}", yytext + 5);
}

<LI>"<b>"[^>]*"</b>" { 
  /**************************************************************************
   * Support for the HTML element <b> within the list element. 
   * It will convert the <b> tag, along with all text within it, into its 
   * LaTeX equivalent \textbf{}.
   *************************************************************************/
  yytext[yyleng-4] = 0;
  printf("\\textbf{%s}", yytext+3);
}

<LI>"<i>"[^>]*"</i>" {
  /**************************************************************************
   * Support for the HTML element <i> within the list element. 
   * It will convert the <i> tag, along with all text within it, into its 
   * LaTeX equivalent \textit{}.
   *************************************************************************/
  yytext[yyleng - 4] = 0; 
  printf("\\textit{%s}", yytext + 3);
}

<LI>"<strong>"[^>]*"</strong>" {
  /**************************************************************************
   * Support for the HTML element <strong> within the list element. 
   * It will convert the <strong> tag, along with all text within it, into its
   * LaTeX equivalent \textmd{}.
   *************************************************************************/
  yytext[yyleng - 9] = 0;
  printf("\\textmd{%s}", yytext + 8);
}

<LI>"<em>"[^>]*"</em>" {
  /**************************************************************************
  * Support for the HTML element <em> within the list element. 
  * It will convert the <em> tag, along with all text within it, into its 
  * LaTeX equivalent \emph{}.
   *************************************************************************/
  yytext[yyleng - 5] = 0;
  printf("\\emph{%s}", yytext + 4);
}

<LI>"<sup>"[^>]*"</sup>" {
  /**************************************************************************
   * Support for the HTML element <sup> within the list element. 
   * It will convert the <sup> tag, along with all text within it, into its
   * LaTeX equivalent \textsuperscript{}.
   *************************************************************************/
  yytext[yyleng - 6] = 0;
  printf("\\textsuperscript{%s}", yytext + 5);
}

<LI>"<sub>"[^>]*"</sub>" {
  /**************************************************************************
   * Support for the HTML element <sub> within the list element .
   * It will convert the <sub> element, along with all text within it, into its
   * LaTeX equivalent \textsubscript{}.
   *************************************************************************/
  yytext[yyleng - 6] = 0; 
  printf("\\textsubscript{%s}", yytext + 5);
}


<LI>"</li>" {
  /**************************************************************************
   * Support to end the HTML <li> element </li>. In this case, it will just
   * print a newline. 
   *
   * Additionally, it will also check the list type variable that was set earlier. 
   * This is done in order to jump back and jump (BEGIN) the correct list that this <li>
   * element is nested within, since both <ol> and <ul> can support multiple <li>
   * elements. 
   *************************************************************************/
  printf("\n");
  if (list_type == 1) {
    BEGIN OL;
  }
  else if (list_type == 2) {
    BEGIN UL;
  }
}

%%

/**************************************************************************
 * The main function for the HTML to LateX converter. Here we do three
 * things:
 *  1. Print out the LateX document header.
 *  2. Invoke the lexer to print out the LateX document
 *  3. Print out the LateX footer.
 *************************************************************************/
int main( int argc, const char *argv[] ) {
    printf( "\\documentclass[12pt]{article}\n" );
    printf( "\\usepackage{fixltx2e}\n" );
    printf( "\n" );
    printf( "\\setlength{\\parindent}{0.0in}\n" );
    printf( "\\setlength{\\parskip}{0.125in}\n" );
    printf( "\n\n" );
    printf( "\\begin{document}\n" );
    yylex();
    printf( "\\end{document}\n" );
    return 0;
}
