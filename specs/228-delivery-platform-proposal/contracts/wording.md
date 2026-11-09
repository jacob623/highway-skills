# Wording Contract

## highway-implementation `execution`

Opening paragraph gains, after "A row with a blank Kind is not a candidate.":

```text
This implementation's row is not a candidate.
```

Step 5 `5. Return to `start`.` becomes:

```text
5. Return to the step that named this one.
```

## highway-implementation `delivery platforms`

New step 3; the Emit step becomes step 4:

```text
3. Hold the record's value for each Execution field. Deployed by and Managed by are unset when `Needed`, empty, or naming a platform with no row. Language is unset when `None` or empty. Hold the `execution` value for each unset field. A value the person named in this visit replaces the held value.
4. Emit:
```

`accept` sentence `Otherwise rewrite the three Execution lines. Change no other byte.` becomes:

```text
Otherwise rewrite the three Execution lines with the held fields. Change no other byte.
```

## highway-implementation Verification

Added after the `delivery platforms` bullet:

```text
- The delivery platforms view holds the record's fields, then the `execution` value for each unset one: Deployed by or Managed by that is `Needed`, empty, or has no row, and Language that is `None` or empty. A value the person named in the visit replaces it. This implementation's row is never a candidate.
```

## Version

`version: 7.6.0` becomes `version: 7.7.0`.
