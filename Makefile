CC=clang++

all: bin/embed bin/encode bin/usr

bin/embed: obj/embed.o
	${CC} -o $@ $^ -static -pthread	-L${RDKIT_ROOT}/lib -lDistGeomHelpers_static -lDistGeometry_static -lFileParsers_static -lForceFieldHelpers_static -lSmilesParse_static -lSubstructMatch_static -lGraphMol_static -lForceField_static -lEigenSolvers_static -lAlignment_static -lRDGeometryLib_static -lRDGeneral_static -L${BOOST_ROOT}/lib -lboost_thread -lboost_system

bin/encode: obj/encode.o
	${CC} -o $@ $^ -L${RDKIT_ROOT}/lib -lFileParsers -lSmilesParse -lSubstructMatch -lGraphMol -lRDGeneral

bin/usr: obj/main.o obj/io_service_pool.o obj/safe_counter.o
	${CC} -o $@ $^ -pthread -L${BOOST_ROOT}/lib -lboost_system -lboost_filesystem -lboost_date_time -L${RDKIT_ROOT}/lib -lMolTransforms -lFingerprints -lFileParsers -lSmilesParse -lSubstructMatch -lGraphMol -lAlignment -lRDGeneral -L${MONGODBCXXDRIVER_ROOT}/sharedclient -lmongoclient

obj/embed.o: src/embed.cpp
	${CC} -o $@ $< -static -c -std=c++14 -O2 -Wall -I${RDKIT_ROOT}/include/rdkit

obj/encode.o: src/encode.cpp
	${CC} -o $@ $< -c -std=c++14 -O2 -Wall -I${RDKIT_ROOT}/include/rdkit

obj/main.o: src/main.cpp
	${CC} -o $@ $< -c -std=c++14 -O2 -Wall -Wno-unused-local-typedef -Wno-deprecated-declarations -Wno-deprecated-register -I${BOOST_ROOT} -I${RDKIT_ROOT}/include/rdkit -I${MONGODBCXXDRIVER_ROOT}/src

obj/%.o: src/%.cpp
	${CC} -o $@ $< -c -std=c++14 -O2 -Wall -I${BOOST_ROOT}

clean:
	rm -f bin/* obj/*
