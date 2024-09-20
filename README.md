# html2latex

A Lex lexical analyzer that will convert a subset of HTML elements into LaTex.

Supports many major HTML elements (headers, paragraphs, ordered and unordered lists). Additionally, it supports the nesting of other elements inside of paragraphs and list items. This includes bold, italicize, superscript, subscript, and more. 


## Requirement: 
todo 


## Running the program
 - Compile the program using `make`

 - Converting from html to LateX: `./html2latex < htmlfilename.html > outputfilename.tex

 - Converting from LaTex (tex) file to PDF: `pandoc -outputfilename.tex -o pdfname.pdf`

## Lex sources used
todo

