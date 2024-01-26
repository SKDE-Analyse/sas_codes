%macro assert_member(varname, list);
/*!
   This macro is similar to [`%assert()`](./assert), but it is made more specifically to test if
   the value of an argument to a macro is valid, i.e., is a member of a list of approved values.

   Example:

   ```
   %let varname = yes;
   %assert_member(varname, yes no goodbye)
   ```

   The example above will not fail, because the value of &varname is indeed a member of "yes no goodbye".
   Take note that the first argument to %assert_member() is not the value of &varname, but rather varname itself.
   This is because %assert_member() need both the value of &varname and the name "varname", so that it can include
   it in the error message.
*/
options minoperator;
%include "&filbane/makroer/assert.sas";


%if %eval(not (&&&varname in (&list))) %then
   %assert(0, message=&&&varname is not a valid value for %str(&)&varname in %nrstr(%%)%sysmexecname(%sysmexecdepth-2)(). These are the options: (&list));
%mend assert_member;