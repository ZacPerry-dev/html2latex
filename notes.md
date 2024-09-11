# Lab notes (9/6) from lecture

- writing lex code to create a parser
    
    
- converting html into LaTeX
    - Multiple different tags, want to account for different "nested" tags

- consider making more test html files
    - Test each functionality individually as you go I guess

## Converting html to latex
- to run: ./html2latex < test.html > test.tex

## Converting latex to pdf
- to run: pandoc -test.tex -o test.pdf

Nesting notes
- Look at the comment as an example
- Going to be multiple instances of different things being nested inside of paragraphs, etc.
- Figure out some of the regex and what it means

- Verbatim is weird
    \begin{verbatim} __Text__ \end{verbatim}

NOTE: Need to go back and add more for pre and paragraph to allow for nested stuff
