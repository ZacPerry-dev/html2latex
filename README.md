# html2latex

A Lex lexical analyzer that will convert a subset of HTML elements into LaTex.

Supports many major HTML elements (headers, paragraphs, ordered and unordered lists). Additionally, it supports the nesting of other elements inside of paragraphs and list items. This includes bold, italicize, superscript, subscript, and more. 

## Requirements

- **Flex (Fast Lexical Analyzer Generator)**: Ensure that you have Flex installed on your machine to compile the Lex source.
- **Pandoc**: For converting LaTeX files to PDFs.
- **Make**: A build tool to automate the compilation process.

## Running the program
 - Compile the program using ```make```

 - Converting from html to LateX: `./html2latex < htmlfilename.html > outputfilename.tex`

 - Converting from LaTex (tex) file to PDF: `pandoc -outputfilename.tex -o pdfname.pdf`

## Future Improvements
 - Add support for more HTML elements
 - Add support for endless nesting
 - Support additional LaTeX features, such as images, tables, etc. 

