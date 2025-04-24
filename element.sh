#!/bin/bash

INPUT="$1"

# If no input provided
if [[ -z "$INPUT" ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Query for element info
RESULT=$(psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c "
SELECT 
  e.atomic_number,
  e.name,
  e.symbol,
  t.type,
  p.atomic_mass,
  p.melting_point_celsius,
  p.boiling_point_celsius
FROM elements e
JOIN properties p ON e.atomic_number = p.atomic_number
JOIN types t ON p.type_id = t.type_id
WHERE e.atomic_number::text = '$INPUT'
   OR LOWER(e.symbol) = LOWER('$INPUT')
   OR LOWER(e.name) = LOWER('$INPUT');
")

# If no result found
if [[ -z "$RESULT" ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse the result into variables
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

# Output the final message
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
