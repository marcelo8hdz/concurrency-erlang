-module(act5_3).
-export([runSecuencial/1, runParallel/1, run/0, readFile/3, processLine/4]).

runSecuencial(File) ->
	T1 = time(),
	readFile(File, "1", "S"),
	readFile(File, "2", "S"),
	readFile(File, "3", "S"),
	readFile(File, "4", "S"),
	T2 = time(),
	T3 = timer:now_diff(T2,T1),
	io:format("Tiempo Secuencial: ~p~n", [T3]).

runParallel(File) ->
	T1 = time(),
	spawn(act5_3, readFile, [File,"1", "P"]),
	T2 = time(),
	T21 = timer:now_diff(T2,T1),
	io:format("Tiempo Paralelo 1: ~p~n", [T21]),
	T3 = time(),
	spawn(act5_3, readFile, [File,"2", "P"]),
	T4 = time(),
	T34 = timer:now_diff(T4,T3),
	io:format("Tiempo Paralelo 2: ~p~n", [T34]),
	T5 = time(),
	spawn(act5_3, readFile, [File,"3", "P"]),
	T6 = time(),
	T56 = timer:now_diff(T6,T5),
	io:format("Tiempo Paralelo 3: ~p~n", [T56]),
	T7 = time(),
	spawn(act5_3, readFile, [File,"4", "P"]),
	T8 = time(),
	T78 = timer:now_diff(T8,T7),
	io:format("Tiempo Paralelo 4: ~p~n", [T78]).

run() ->
	runSecuencial("case"),
	runParallel("case").

processLine(_, _, _, false) -> done;

processLine(Lines, N, SOut, _) -> 
	Line = lists:nth(N,Lines),
	LineSplt = string:split(Line, " ", all),
	Op1 = list_to_integer(lists:nth(1, LineSplt)),
	Op2 = lists:nth(2, LineSplt),
	Op3 = list_to_integer(lists:nth(1, string:split(lists:nth(3, LineSplt), "\n", all))),

	case Op2 of
		"+" ->
			Result = Op1 + Op3;
		"/" ->
			Result = Op1 / Op3;
		"*" ->
			Result = Op1 * Op3;
		"-" ->
			Result = Op1 - Op3;
		"%" ->
			Result = Op1 rem Op3
	end,
	io:format(SOut, "~p~n", [Result]),
	Len = length(Lines),
	if
		N == Len-1 -> processLine(Lines, N+1, SOut, false);
		true -> processLine(Lines, N+1, SOut, true)
	end.

readFile(File, N, Type) ->
	FileIn = File ++ N ++ ".in",
	FileOut = File ++ N ++ Type ++ ".out",
	{ok,SOut} = file:open(FileOut, [write]),
	Lines = string:split(binary_to_list(element(2,file:read_file(FileIn))), "\n", all),
	processLine(Lines, 1, SOut, true).