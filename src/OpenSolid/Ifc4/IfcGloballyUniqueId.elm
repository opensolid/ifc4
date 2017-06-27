module OpenSolid.Ifc4.GloballyUniqueId exposing (generator)

import Array.Hamt as Array
import Bitwise
import OpenSolid.Ifc4.Types exposing (..)
import Random.Pcg as Random exposing (Generator)


generator : Generator IfcGloballyUniqueId
generator =
    let
        characters =
            "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_$"
                |> String.split ""
                |> Array.fromList

        toCharacter value =
            Array.get value characters |> Maybe.withDefault ""

        twoBitGenerator =
            Random.int 0 3

        fourBitGenerator =
            Random.int 0 15

        sixBitGenerator =
            Random.int 0 63

        characterGenerator =
            Random.map toCharacter sixBitGenerator

        highCharacterGenerator =
            twoBitGenerator |> Random.map toCharacter

        highSevenCharactersGenerator =
            Random.list 7 characterGenerator |> Random.map String.concat

        highVersionCharacterGenerator =
            fourBitGenerator
                |> Random.map
                    (\fourBits ->
                        toCharacter (Bitwise.shiftLeftBy 2 fourBits + 1)
                    )

        lowVersionCharacterGenerator =
            fourBitGenerator |> Random.map toCharacter

        variantCharacterGenerator =
            Random.map2
                (\highBits lowBits ->
                    toCharacter (Bitwise.shiftLeftBy 4 highBits + 8 + lowBits)
                )
                twoBitGenerator
                twoBitGenerator

        lowTenCharactersGenerator =
            Random.list 10 characterGenerator |> Random.map String.concat

        buildGuid highCharacter highSevenCharacters highVersionCharacter lowVersionCharacter midCharacter variantCharacter lowTenCharacters =
            IfcGloballyUniqueId <|
                highCharacter
                    ++ highSevenCharacters
                    ++ highVersionCharacter
                    ++ lowVersionCharacter
                    ++ midCharacter
                    ++ variantCharacter
                    ++ lowTenCharacters
    in
    Random.map buildGuid highCharacterGenerator
        |> Random.andMap highSevenCharactersGenerator
        |> Random.andMap highVersionCharacterGenerator
        |> Random.andMap lowVersionCharacterGenerator
        |> Random.andMap characterGenerator
        |> Random.andMap variantCharacterGenerator
        |> Random.andMap lowTenCharactersGenerator
