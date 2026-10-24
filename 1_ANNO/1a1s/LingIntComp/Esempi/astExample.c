int expressionResult(int expr){
	if(expr == 1){
		expr += 10;
	}
	else{
		expr = 0;
	}

	return expr;

}

int main(int argc, char* argv[]){
	
	return expressionResult(argc);

}
