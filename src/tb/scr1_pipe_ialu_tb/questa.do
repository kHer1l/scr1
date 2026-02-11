# Печать в консоль запускаемых команд.
transcript on

# Удаление директории и библиотеки, если существует.
if {[file exists temp_work]} { 
	vdel -lib temp_work -all
}

# Создание библиотеки
vlib temp_work

# Привязка библиотеки к work.
vmap work temp_work

# Компиляция исходника счетчика.
vlog ../../core/pipeline/scr1_pipe_ialu.sv +incdir+../../includes
#vlog sv/*.sv +incdir+../../includes
vlog "+incdir+../../includes" \
	sv/scr1_pkg.sv \
	sv/scr1_pipe_ialu_if.sv \
	sv/scr1_pipe_ialu_package.sv \
	sv/scr1_pipe_ialu_tb_top.sv 


# Запуск симуляции
vsim -gui work.scr1_pipe_ialu_tb_top -voptargs=+acc -coverage -voptargs="+cover=sb+/scr1_pipe_ialu_tb_top/dut"
#vsim -gui work.scr1_pipe_ialu_tb_top -voptargs=+acc


# Добавление сигналов в окно временных диаграм
add wave sim:/scr1_pipe_ialu_tb_top/scr1_pipe_ialu_if_h/*
#add wave *

# Запуск 
run -a

# Сохранение отчёта о кодовом покрытии в файл базы данных
#coverage save cov.ucdb
# Открытие отчёта о кодовом покрытии из файла базы данных
#vsim -viewcov cov.ucdb
# Сохранение отчёта о кодовом покрытии в текстовый файл
coverage report -details -file coverage_report.txt