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


NOTE: Need to go back and add more for pre and paragraph to allow for nested stuff

NOTE:
- Go back and test with different HTML files -> Run mine then the sol fil. Compare the LaTeX files to see if mine is correct. 

NOTE: 
- For list items: Start LI -> do same thing as paragraph
  - LI is weird. Right now, trying to get it to also just print regular list items is tough.
  - Need to deal with spacing as well
- NOTE: may need to go back and change Paragraph for something? 

