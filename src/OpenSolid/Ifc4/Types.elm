module OpenSolid.Ifc4.Types exposing (..)


type IfcGloballyUniqueId
    = IfcGloballyUniqueId String


type alias IfcRoot a =
    { a
        | globalId : IfcGloballyUniqueId
    }


type alias IfcObjectDefinition a =
    IfcRoot a


type alias IfcContext a =
    IfcObjectDefinition
        { a
            | objectType : Maybe String
            , longName : Maybe String
            , phase : Maybe String
        }


type alias IfcProject =
    IfcContext {}
