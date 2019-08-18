# cat pairsRR.txt | awk -f make-pair-codes.awk >pair-codes.txt

/^2019/ {
	print "Round	" $5;
	print "	Result		";
} $2 ~ /^=$/ {
	split ($0, a, /[=\-]/);
	split (a[2], white);
	split (a[3], black);
	print white[1] "		" black[1];
}
