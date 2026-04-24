TARGET = analyzer
SRC = src/analyzer.s
OBJ = analyzer.o

AS = as
LD = ld

.PHONY: all run test clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) -o $(TARGET) $(OBJ)

$(OBJ): $(SRC)
	$(AS) -o $(OBJ) $(SRC)

run: all
	cat data/logs_D.txt | ./$(TARGET)

test: all
	bash tests/test.sh

clean:
	rm -f $(TARGET) $(OBJ)
