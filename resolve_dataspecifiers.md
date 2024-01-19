
# Dokumentasjon for filen *makroer/resolve_dataspecifiers.sas*


## Makro `resolve_dataspecifiers`

   This helper macro parses +-delimited dataspecifiers of the form
   `(<library>.)<datasets>/<variables>(/<format-1> ... <format-n>) (+ <dataspecifier>) (#<label-1> ... #<label-n>)`.
   All the variables (and their values) in all the datasets are added to the output table in chronological order, but
   the variables are renamed to `&prefix._<n>`, where `<n>` starts at 1 and increases as new variables are added to the
   output dataset. This ensures that all the columns have unique variable names.

   Both `<datasets>` and `<variables>` are SAS variable lists, and are therefore
   very flexible. If both `<datasets>` and `<variables>` is a variable list of length
   greater than 1, the result is essentially a cartesian product; all combinations
   are added to the output dataset in the most logical order.

   More detailed information on how dataspecifiers work, with many examples, can be found in the dokumentation for [`%graf()`](./graf).
