FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev 
RUN git clone https://github.com/p-ranav/csv2.git
WORKDIR /csv2
RUN cmake -DCMAKE_C_COMPILER=afl-gcc -DCMAKE_CXX_COMPILER=afl-g++ .
RUN make
RUN make install
WORKDIR ./benchmark
RUN afl-g++ -I../include -O3 -std=c++11 -o main main.cpp
RUN mkdir /csvCorpus
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/addresses.csv
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/airtravel.csv
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/biostats.csv
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/example.csv
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/homes.csv
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/hooke.csv
RUN wget https://people.sc.fsu.edu/~jburkardt/data/csv/cities.csv
RUN mv *.csv /csvCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib/

ENTRYPOINT ["afl-fuzz", "-i", "/csvCorpus", "-o", "/csv2Out"]
CMD ["/csv2/benchmark/main", "@@"]
