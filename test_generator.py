import random

EXAMS = ['analisi_matematica', 
'programmazione_e_laboratorio', 
'fisica', 
'matematica_discreta', 
'architettura_degli_elaboratori_e_laboratorio', 
'algoritmi_e_strutture_dati_e_laboratorio', 
'calcolo_delle_probabilita_statistica', 
'calcolo_scientifico', 
'fondamenti_informatica', 
'programmazione_orientata_oggetti', 
'logica_matematica', 
'sistemi_operativi_e_laboratorio', 
'basi_di_dati', 
'ignegneria_del_software', 
'interazione_uomo_macchina', 
'informatica_medica', 
'internet_of_things'
'linguaggi_di_programmazione'
'reti_di_calcolatori',]
# 'advanced_database_systems_for_big_data'
# 'advanced_data_science', 
# 'algoritmi_avanzati', 
# 'analisi_e_verifica_mediante_interpretazione_astratta', 
# 'auditory_and_tactile_interactions', 
# 'complessita_e_teoria_informazione',
# 'computer_vision', 
# 'deep_learning', 
# 'droni_e_sistemi_robotici_autonomi', 
# 'foundations_of_neural_networks', 
# 'geometria_computazionale',
# 'informatica_e_diritto', 
# 'information_retrieval', 
# 'information_visualization', 
# 'ingegneria_del_software_progettazione_e_laboratorio', 
# 'intelligenza_artificiale',
# 'interactive_3d_graphics', 
# 'linguaggi_e_compilatori', 
# 'logica_per_informatica', 
# 'metodi_formali_per_informatica', 
# 'progettazione_di_applicazioni_mobili', 
# 'progettazione_e_analisi_orientate_agli_oggetti', 
# 'programmazione_su_architetture_parallele', 
# 'quantum_computing_and_communication', 
# 'ragionamento_automatico', 
# 'recommender_systems', 
# 'ricerca_operativa_e_statistica_applicata_e_analisi_dei_dati', 
# 'semantica_dei_linguaggi_di_programmazione', 
# 'sicurezza_delle_reti_di_calcolatori', 
# 'sistemi_distribuiti', 
# 'verifica_automatica_dei_sistemi_teoria_e_applicazioni', 
# 'video_game_programming', 
# 'virtual_reality_and_persuasive_user_experience', 
# 'web_semantico']

SLOTS = ['m', 'p']  # m = mattina, p = pomeriggio

ROOMS = ["a1", "a2"]


class TestDataGenerator:
    
    def create_students(self,n):
        students = []
        for i in range(0,n):
            students.append(i)
        return students

    def create_booking_array(self,n):
        booking = []
        students = self.create_students(n)
        for _ in students:
            exams = []
            for _ in EXAMS:
                booked = random.uniform(0,1)
                if booked >= 0.5:
                    exams.append('1')
                else:
                    exams.append('0')
            booking.append(exams)
        return booking

class MinizincTestGenerator:

    def write_exams_on_file(self, file):
        file.write('EXAMS = {')
        for i in EXAMS:
            file.write(f'\'{i}\',\n')
        file.write('};')
        file.write('\n')

    def write_students_on_file(self,students,file):
        file.write('STUDENTS={')
        for i in students:
            file.write(f'\'{i}\',\n')
        file.write('};')
        file.write('\n')

    def write_booking_on_file(self,booking,file):
        file.write('booking = [|')
        for i in booking:
            for j in i:
                file.write(f'{j},')
            file.write('|')
        file.write('];\n')
    
    def write_slots_on_file(self,file):
        file.write('SLOTS = {')
        for i in SLOTS:
            file.write(f'\'{i}\',\n')
        file.write('};')
        file.write('\n')
    
    def write_rooms_on_file(self,file):
        file.write('ROOMS = {')
        for i in ROOMS:
            file.write(f'\'{i}\',\n')
        file.write('};')
        file.write('\n')

class AspTestDataCreator:
    
    def create_days(self,n):
        return f"day(1..{n}).\n"

    def write_day(self,n,file):
        days = self.create_days(n)
        file.write(days)

    def write_booking(self, students, booking,file):
        for s in students:
                for e in range(0,len(EXAMS)):
                    if booking[int(s)][e] == '1':
                        file.write(f"book({s},{EXAMS[e]}).\n")
                        
    def write_students(self, number_of_students, file):
        # for s in students:
        #     file.write(f'student({s}).\n')
        file.write(f'student(0..{number_of_students-1}).\n')

    def write_slots(self,file):
        for slot in SLOTS:
            file.write(f"slot({slot}).\n")
    
    def write_exams(self,file):
        for exam in EXAMS:
            file.write(f"exam({exam}).\n")
    
    def write_rooms(self,file):
        for room in ROOMS:
            file.write(f"room({room}).\n")
    

class Main:

    tdg = TestDataGenerator()
    mtg = MinizincTestGenerator()
    atg = AspTestDataCreator()

    def main(self,number_of_students,minizinc_data_file, asp_data_file):

        # Minizinc test creation
        students = self.tdg.create_students(number_of_students)
        booking = self.tdg.create_booking_array(number_of_students)
        minizinc_test_file = open(minizinc_data_file,"w+")
        self.mtg.write_exams_on_file(minizinc_test_file)
        self.mtg.write_booking_on_file(booking,minizinc_test_file)
        self.mtg.write_students_on_file(students,minizinc_test_file)
        self.mtg.write_rooms_on_file(minizinc_test_file)
        self.mtg.write_slots_on_file(minizinc_test_file)
        minizinc_test_file.close()
        
        #ASP test creator
        days_upper_bound = 60
        asp_test_file = open(asp_data_file,'w+')
        self.atg.write_day(days_upper_bound,asp_test_file)
        self.atg.write_students(number_of_students,asp_test_file)
        self.atg.write_booking(students,booking,asp_test_file)
        self.atg.write_exams(asp_test_file)
        self.atg.write_rooms(asp_test_file)
        self.atg.write_slots(asp_test_file)
        asp_test_file.close()


        print("Tests created")
        

for i in range(0,10):
    Main().main(100,f'data{i}.dzn',f'data{i}.lp')