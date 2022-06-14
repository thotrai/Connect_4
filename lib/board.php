<?php

//epistrofi tou board meta th read_board()
function show_board($input) {
	
	global $mysqli;
	
	header('Content-type: application/json');
		print json_encode(read_board(), JSON_PRETTY_PRINT);
}

//sql request gia katharismo tou pinaka
function reset_board() {
	global $mysqli;
	
	$sql = 'call clean_board()';
	$mysqli->query($sql);
}

//sql request gia emfanisi sigkekrimenou koutiou apo to board
function show_piece($x,$y,$token) {
	global $mysqli;
	
	$sql = 'select * from board where x=? and y=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('ii',$x,$y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

//elegxos ths kinhshs kai kalesma ths do_move()   
function move_piece($x,$y,$token) {
	
	if($token==null || $token=='') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Token is not set."]);
		exit;
	}
	
	$color = current_color($token);
	if($color==null ) {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"You are not a player of this game."]);
		exit;
	}
	$status = read_status();
	if($status['status']!='started') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Game is not in action."]);
		exit;
	}
	if($status['p_turn']!=$color) {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"It is not your turn."]);
		exit;
	}
	
	do_move($x,$y);	
	
}

//sql request gia epistrofi tou board
function read_board(){
	global $mysqli;
	$sql = 'select * from board';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	return($res->fetch_all(MYSQLI_ASSOC));
}		

//sql request gia na ginei h kinhsh kai update tou game_status
function do_move($x,$y) {
	global $mysqli;
	$sql = 'call `move_piece`(?,?);';
	$st = $mysqli->prepare($sql);
	$st->bind_param('ii',$x,$y);
	$st->execute();
	
	header('Content-type: application/json');
	print json_encode(read_board(), JSON_PRETTY_PRINT);
}

//sql request gia emfanisi nikhth
function show_winner(){
	global $mysqli;
	
	$sql = 'call show_winner()';
	$mysqli->query($sql);
}

//sql request gia emfanisi isopalias
function show_result(){
	global $mysqli;
	
	$sql = 'call show_result()';
	$mysqli->query($sql);
}

?>

