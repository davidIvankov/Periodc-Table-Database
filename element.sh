if [[ -z $1 ]]
then
echo Please provide an element as an argument.
elif [[ $1 ]] && [[ $1 = [0-9]* ]]
then
NAME_N=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
SYMBOL_N=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
TYPE_N=$($PSQL "SELECT type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
ATOMIC_MASS_N=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
MELTING_POINT_N=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
BOILING_POINT_N=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
if [[ -z $NAME_N ]]
then 
echo I could not find that element in the database.
else
echo "The element with atomic number $1 is $NAME_N ($SYMBOL_N). It's a $TYPE_N, with a mass of $ATOMIC_MASS_N amu. $NAME_N has a melting point of $MELTING_POINT_N celsius and a boiling point of $BOILING_POINT_N celsius."
fi
elif [[ ! $1 = [0-9]* ]]
then
NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1'")
TYPE=$($PSQL "SELECT type FROM properties FULL JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements USING(atomic_number) WHERE name='$1' OR symbol='$1'")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE name='$1' OR symbol='$1'")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE name='$1' OR symbol='$1'")
if [[ -z $NAME ]] && [[ -z $SYMBOL ]]
then 
echo I could not find that element in the database.
elif [[ -z $NAME ]]
then
echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
elif [[ -z $SYMBOL ]]
then
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
fi