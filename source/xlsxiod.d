module xlsxiod;

import xlsxio;

string[][string] readSheetAsTable(string path, string sheetName, int headerRow) {
	string[][string] ret;
	auto rows = readSheet(path,sheetName);
	auto keys = rows[headerRow];
	foreach(i;0..keys.length)
	{
		foreach(j;headerRow+1 .. rows.length)
		{
			ret[keys[i]] ~= rows[j][i];
		}
	}
	return ret;
}

string[][string] readSheetAsTable2(string path, string sheetName, int headerRow)
{
	static import dlang_xml_xlsx_reader;
	import std.exception;
	import std.format: format;

	string[][string] ret;
	auto rows = dlang_xml_xlsx_reader.readSheetByName(path,sheetName);
	auto keys = rows[headerRow];
	foreach(i; 0 .. keys.length) {
		foreach(j; headerRow + 1 .. rows.length) {
			ret[keys[i]] ~= rows[j][i];
		}
	}
	return ret;
}


auto parseExcelLocation(string location) {
	import std.regex : regex, matchFirst;
	import std.conv : parse;
	auto pat = regex("([A-Z]+)([0-9]+)");
	auto m = location.matchFirst(pat);
	string rrow = m[2];
	return [parse!int(rrow) - 1, m[1].columnNameToNumber - 1];
}

int columnNameToNumber(string col) {
	import std.range:retro,enumerate;
	int num;
	foreach(i, c; enumerate(col.retro)) {
		num += (c - 'A' + 1)*26^^i;
	}
	return num;
}

enum : int {
	XlsxioFreeNo = 0,
	XlsxioFreeYes = 1,
}

string[] sheetNames(string workbookFilename) {
	import xlsxio;
	import std.file : read;
	import std.array : array, Appender;
	import std.exception;
	import std.format : format;
	import core.stdc.stdlib:free;
	import std.conv : to;
	import std.string : fromStringz;
	import std.utf : toUTF8;

	Appender!(string[]) ret;
	XLSXIOCHAR* sheetname;

	auto buf = cast(ubyte[]) read(workbookFilename);
	xlsxioreader xlsxioread = xlsxioread_open_memory(buf.ptr,buf.length,
			XlsxioFreeNo
		);
	enforce(xlsxioread !is null, "error opening " ~ workbookFilename);

	scope(exit) {
		xlsxioread_close(xlsxioread);
	}

	xlsxioreadersheetlist sheetList = xlsxioread_sheetlist_open(xlsxioread);
	scope(exit) {
		xlsxioread_sheetlist_close(sheetList);
	}

	enforce(sheetList !is null, "error opening sheets from " ~
			workbookFilename
		);

	while( (sheetname = cast(XLSXIOCHAR*)xlsxioread_sheetlist_next(sheetList))
			!is null)
	{
		// required when building xlsxio in unicode version
		ret.put(sheetname.fromStringz.to!string);
	}
	return ret.data;
}

string[][] readSheet(string workbookFilename, string sheetName, uint flags = 0) {
	import xlsxio;
	import std.file:read;
	import std.array:array, Appender;
	import std.exception;
	import std.format: format;
	import core.stdc.stdlib:free;
	import std.conv:to;
	import std.utf: toUTF8;
	import std.string:fromStringz;

	Appender!(string[][]) ret;

	auto buf = cast(ubyte[]) read(workbookFilename);
	xlsxioreader xlsxioread = xlsxioread_open_memory(buf.ptr,buf.length,XlsxioFreeNo);
	enforce(xlsxioread !is null, "error opening " ~ workbookFilename);

	scope(exit) {
		xlsxioread_close(xlsxioread);
	}

	xlsxioreadersheet sheet = xlsxioread_sheet_open(xlsxioread,
			sheetName.toXlsxioString(), flags
		);
	enforce(sheet !is null, format!"error opening sheet %s from %s"(
				sheetName, workbookFilename)
		);

	scope(exit) {
		xlsxioread_sheet_close(sheet);
	}

	XLSXIOCHAR* value;
	Appender!(string[]) rowRet;
	while(xlsxioread_sheet_next_row(sheet)) {
		while( (value = xlsxioread_sheet_next_cell(sheet)) !is null) {
			rowRet.put(value.fromStringz.toUTF8);
			free(value);
		}
		ret.put(rowRet.data);
	}
	return ret.data;
}

private auto toXlsxioString(string s) {
	import std.utf:toUTF16z, toUTF8;
	import std.string:toStringz;
	version(XmlUnicode) {
		return s.toUTF16z;
	} else {
		return s.toStringz;
	}
}
