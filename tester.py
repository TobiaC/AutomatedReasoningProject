import os


for i in range(0,10):
    str_lp_simple = (f"clingo --outf=1 --time-limit=300 exams_scheduler.lp testsSimple/data{i}.lp")
    str_dzn_simple = (f"minizinc --solver Chuffed -f --time-limit 300000 --output-time exams_scheduler.mzn testsSimple/data{i}.dzn")
    str_lp_medium = (f"clingo --outf=1 --time-limit=300 exams_scheduler.lp /testsMedium/data{i}.lp")
    str_dzn_medium = (f"minizinc --solver Chuffed -f --time-limit 300000 --output-time exams_scheduler.mzn testsMedium/data{i}.dzn")
    str_lp_large = (f"clingo --outf=1 --time-limit=300 exams_scheduler.lp testsLarge/data{i}.lp")
    str_dzn_large = (f"minizinc --solver Chuffed -f --time-limit 300000 --output-time exams_scheduler.mzn testsLarge/data{i}.dzn")
    os.system(str_dzn_simple + " > " + f"out{i}_minizinc_simple.txt")
    os.system(str_lp_simple + " > " + f"out{i}_asp_simple.txt")
