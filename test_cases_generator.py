# board sizes to test: 10, 15, 20, 25
# for each board size 25 test cases

from random import randint



class TestGenerator:

    board_sizes = [10,15,20,25]

    def generate_chessboard_instance(self):
        for size in self.board_sizes:
            for i in range(0,25):
                N = size
                R,S,L = self.generates_number_of_figures(size)
                n_black_boxes, black_boxes_coordinates = self.generates_black_boxes(size)
                file = open(f"test_cases/test_case {size,i}","w+")
                file.write(str(L)+"\n")
                file.write(str(N)+"\n")
                file.write(str(R)+"\n")
                file.write(str(S)+"\n")
                file.write(str(black_boxes_coordinates)+"\n")
                file.write(str(n_black_boxes)+"\n")
                file.close()

    def generates_number_of_figures(self, board_size):
        number_of_rectangles = randint(0,board_size*board_size)
        number_of_squares = randint(0,board_size*board_size)
        number_of_l_shapes = randint(0,board_size*board_size)
        return number_of_rectangles,number_of_squares,number_of_l_shapes

    def generates_black_boxes(self, board_size):
        number_of_black_boxes = randint(0,board_size*board_size)
        coord = []
        for _ in range(0,number_of_black_boxes):
            # [|1,1,|2,2,|3,3|]
            x = randint(0,board_size)
            y = randint(0,board_size)
            coord.append("|" + str(x) + "," + str(y))
        coordinates = (", ".join(coord))
        coordinates = "[" + coordinates + "|]"
        return number_of_black_boxes, coordinates


def main():
    test_generator = TestGenerator()
    test_generator.generate_chessboard_instance()










if __name__=='__main__':
    main()