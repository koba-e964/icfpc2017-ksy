urls=("http://punter.inf.ed.ac.uk/maps/sample.json" "http://punter.inf.ed.ac.uk/maps/lambda.json" "http://punter.inf.ed.ac.uk/maps/Sierpinski-triangle.json" "http://punter.inf.ed.ac.uk/maps/circle.json" "http://punter.inf.ed.ac.uk/maps/randomMedium.json" "http://punter.inf.ed.ac.uk/maps/randomSparse.json" "http://punter.inf.ed.ac.uk/maps/tube.json" "http://punter.inf.ed.ac.uk/maps/oxford-center-sparse.json" "http://punter.inf.ed.ac.uk/maps/oxford2-sparse-2.json" "http://punter.inf.ed.ac.uk/maps/edinburgh-sparse.json" "http://punter.inf.ed.ac.uk/maps/boston-sparse.json" "http://punter.inf.ed.ac.uk/maps/nara-sparse.json" "http://punter.inf.ed.ac.uk/maps/van-city-sparse.json" "http://punter.inf.ed.ac.uk/maps/gothenburg-sparse.json")
for url in "${urls[@]}"
do
    curl -O ${url}
done