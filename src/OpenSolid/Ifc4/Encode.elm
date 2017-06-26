module OpenSolid.Ifc4.Encode
    exposing
        ( ifcAxis2Placement2d
        , ifcAxis2Placement3d
        , ifcCartesianPoint2d
        , ifcCartesianPoint3d
        , ifcDirection2d
        , ifcDirection3d
        )

import OpenSolid.Direction2d as Direction2d
import OpenSolid.Direction3d as Direction3d
import OpenSolid.Frame2d as Frame2d
import OpenSolid.Frame3d as Frame3d
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point2d as Point2d
import OpenSolid.Point3d as Point3d
import OpenSolid.Step as Step
import OpenSolid.Step.Encode as Encode


ifcCartesianPoint2d : Point2d -> Step.Entity
ifcCartesianPoint2d point =
    Encode.entity "IFCCARTESIANPOINT"
        [ Encode.list
            [ Encode.float (Point2d.xCoordinate point)
            , Encode.float (Point2d.yCoordinate point)
            ]
        ]


ifcCartesianPoint3d : Point3d -> Step.Entity
ifcCartesianPoint3d point =
    Encode.entity "IFCCARTESIANPOINT"
        [ Encode.list
            [ Encode.float (Point3d.xCoordinate point)
            , Encode.float (Point3d.yCoordinate point)
            , Encode.float (Point3d.zCoordinate point)
            ]
        ]


ifcDirection2d : Direction2d -> Step.Entity
ifcDirection2d direction =
    Encode.entity "IFCDIRECTION"
        [ Encode.list
            [ Encode.float (Direction2d.xComponent direction)
            , Encode.float (Direction2d.yComponent direction)
            ]
        ]


ifcDirection3d : Direction3d -> Step.Entity
ifcDirection3d direction =
    Encode.entity "IFCDIRECTION"
        [ Encode.list
            [ Encode.float (Direction3d.xComponent direction)
            , Encode.float (Direction3d.yComponent direction)
            , Encode.float (Direction3d.zComponent direction)
            ]
        ]


ifcAxis2Placement2d : Frame2d -> Step.Entity
ifcAxis2Placement2d frame =
    let
        originPoint =
            ifcCartesianPoint2d (Frame2d.originPoint frame)

        xDirection =
            ifcDirection2d (Frame2d.xDirection frame)
    in
    Encode.entity "IFCAXIS2PLACEMENT2D"
        [ Encode.referenceTo originPoint
        , Encode.referenceTo xDirection
        ]


ifcAxis2Placement3d : Frame3d -> Step.Entity
ifcAxis2Placement3d frame =
    let
        originPoint =
            ifcCartesianPoint3d (Frame3d.originPoint frame)

        zDirection =
            ifcDirection3d (Frame3d.zDirection frame)

        xDirection =
            ifcDirection3d (Frame3d.xDirection frame)
    in
    Encode.entity "IFCAXIS2PLACEMENT3D"
        [ Encode.referenceTo originPoint
        , Encode.referenceTo zDirection
        , Encode.referenceTo xDirection
        ]
