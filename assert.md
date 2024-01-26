
# Dokumentasjon for filen *makroer/assert.sas*


## Makro `assert`

   This macro will stop executing SAS code if the assertion fails. Example:

   ```
   %assert(1 eq 2, message=One is not two);
   ```

   This assertion will fail, and this error message will be printed to the log: "ERROR: One is not two. Aborting!"
   SAS is made to continue running code even though errors happen. This makes it difficult to debug SAS
   programs. Furthermore, to continue running a program has an error is potentially harmful, because
   it is no longer clear what the code further down the line will do if it depended on the code that failed
   (which it very often does). It is therefore a good idea to stop SAS from executing as soon as an error occurs
   by using this macro.

   For a different variant used to verify that arguments to macros are correct, see  [`%assert_member()`](./assert_member) 
