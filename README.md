# The Martian Times

Martian Times news is a reader application for the latest emerging market -- Mars!

## Requirements

 - It has to be a native application and no webviews should be used.
 - Articles should be dynamically fetched from https://s1.nyt.com/ios-newsreader/candidates/test/articles.json
 - At least 2 screens should be implemented: a list of articles and an article view.
 - One image per article (its "top image") should be displayed on both the list screen and the article screen. All other images may be discarded.
 - The user should be able to dynamically toggle the language preference from English to Martian.
 - Language selection should be persisted across runs.
 - The following translation rules apply for translating English to Martian:

   1. All words greater than 3 characters should be translated to the word "boinga"
   2. Numbers should not be translated unless embedded within a word.
  (ex. “20,000 Leagues Under the Sea” should translate to “20,000 Boinga Boinga the Sea”, whereas “fri3nd” should translate to just “boinga”.
   3. Capitalization must be maintained
   4. Punctuation within words (e.g. we'll) can be discarded, all other punctuation (including paragraph spacing) must be maintained.
   5. The application needs test cases verifying Martian translation. Additional Test cases should be implemented as needed.
      For example, “Is there life on Mars?” should be translated to “Is boinga boinga on Boinga?”
 - Consider this application a showcase of your engineering prowess. You are free to use any architecture and patterns that you prefer. Third party libraries are allowed in all contexts except networking and image handling. System libraries are fine to use everywhere.
 - The length of time spent to complete this exercise will not affect our evaluation. We understand that you are likely to have many things, both personally and professionally, that may slow you down. Your code will, however, be evaluated for architecture, style, clarity, and approach.


## License
[MIT](https://choosealicense.com/licenses/mit/)
