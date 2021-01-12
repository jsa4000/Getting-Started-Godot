class_name Global

enum ConnectorType { 
	NONE = -1, 
	INPUT, 
	OUTPUT 
}

enum DataType { 
	UNKNOWN = -1
	BOOL,
	SCALAR, 
	VECTOR2, 
	VECTOR3, 
	MATRIX, 
	STRING,
	FILE,
	IMAGE, 
	MATERIAL,
	GEOMETRY,
	CAMERA
}

const DataTypeColor = {
	DataType.UNKNOWN : Color( "#ffffff" ),
	DataType.BOOL : Color( "#3366cc" ), 
	DataType.SCALAR : Color( "#336699" ), 
	DataType.VECTOR2: Color( "#0000cc" ), 
	DataType.VECTOR3 : Color( "#000066" ), 
	DataType.MATRIX : Color( "#333300" ), 
	DataType.STRING : Color( "#009999" ), 
	DataType.FILE : Color( "#004d00" ), 
	DataType.IMAGE : Color( "#666699" ), 
	DataType.MATERIAL : Color( "#666699" ), 
	DataType.GEOMETRY : Color( "#800000" ), 
	DataType.CAMERA : Color( "#660066" ), 
}

const DataTypeControl = {
	DataType.UNKNOWN : "TextEditControl",
	DataType.BOOL : "BoolControl",
	DataType.SCALAR : "ScalarControl",
	DataType.VECTOR2: "Vector2Control",
	DataType.VECTOR3 : "Vector3Control", 
	DataType.MATRIX : "Vector3Control",
	DataType.FILE : "OpenFileControl",
	DataType.IMAGE : "TextEditControl",
	DataType.MATERIAL : "TextEditControl",
	DataType.GEOMETRY :"TextEditControl",
	DataType.CAMERA : "TextEditControl",
}

