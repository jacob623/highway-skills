# Record

Write the accepted proposal as one record.

### identifier

1. List the existing records.
2. Take the next free number.
3. Go to `write`.

The number is never reused, even after a record is removed.

The number has three digits, padded with zeros.

### write

1. Write the record with the accepted proposal.
2. Add the record to the catalog.
3. Return to `close`.

The record holds only what the person accepted.

The catalog entry names the record's number and title.

Nothing is written when the person has not accepted.

## Verification
- The record's number was free before `write`.
- The catalog names the new record.
