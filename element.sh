#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
else
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE name='$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
do
  PROP=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo $PROP | while IFS="|" read ATOMIC_NUMBER_PROP ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
  do
    TYPE_NAME=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
done
