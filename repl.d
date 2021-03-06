import std;
import core.stdc.stdlib;

int main()
{
	string lastOutput;

	system("cls");
	writeln("Welcome to repel-d!\n");

	writeln("Type and expression and press enter to evaluate, cls to clear");
	writeln("Examples: 2+2 or \"Testing\"");
	writeln("For network functionality, type network.get etc (std.net.curl). Example network.get(\"dlang.org\")\n");

	writeln("Use 'f ' as prefix to use writefln, like: f \"%d is %b in binary\", 23, 23");
	writeln("Use 'e ' as prefix to execute a shell command, like: e dir");
	writeln("Use 'r ' as prefix for raw input, like: r mixin(\"int x = 2;\"); writeln(x);");
	writeln("Use # to refer to last output\n");

	while (true)
	{
		write("> ");
		string r = readln().chomp;

		if (r == "cls")
		{
			system("cls");
			continue;
		}

		string cmd;

		const string sw = r.length > 2 ? r[0 .. 2] : r;

		switch (sw)
		{
			case "e ":
				cmd = r[2 .. $];
				break;

			case "f ":
				r = "writefln(" ~ r[2 .. $] ~ ");";
				break;

			case "r ":
				r = r[2 .. $];
				break;

			default:
				r = "writeln(" ~ r ~ ");";
		}

		if (sw != "e ")
		{
			if (r.indexOf("net.") != -1)
			{
				r = "import std.net.curl; " ~ r.replace("net.", "");
			}

			cmd = "rdmd --eval=\"" ~ r.replace("#", lastOutput).replace("\"",
					"`").replace("``", "`").strip ~ "\"";
		}

		string output = executeShell(cmd).output.chomp.strip;
		writeln(output.replace("\\r", "\r").replace("\\n", "\n"));

		lastOutput = output.replace("\r", "\\r").replace("\n", "\\n");
	}

	return 0;
}
