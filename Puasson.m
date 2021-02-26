pkg load statistics
format long

lambda = 1.24;
A = poissrnd(lambda,1,200);
A_sort = sort(A);

%Запись массива в файл
f=fopen('puasson.txt','wt');
for i=1:200
  fprintf(f,'%d\t',A_sort(i));
end
fclose(f);

%Массив данных распределения Пуассона 
f=fopen('puas.txt','rt');
for i=1:200
  A(i) = fscanf(f,'%d\t',1);
end
fclose(f);
A

%Полигон относительных частот для распределения Пуассона
N = [60,64,42,25,6,3]; %Массив значений ni
x = [0:5];
w = N/200;
P = [0.28938,0.35884,0.22248,0.09196,0.02851,0.00707];
plot(x, w, 's-*', x, P, 'r-*')
grid on
grid minor

%Эмпирическая функция распределения Пуассона
S = [0.3,0.62,0.83,0.955,0.985,1];
figure
stairs(x, S)
grid on
grid minor

%Выборочное среднее
function res = v_sred(x, w)
  res = 0;
  for i = 1:6
    xx = x(i)*w(i);
    res = res + xx;
  endfor
end

%Выборочный момент к-ого порядка
function res = v_moment(x, w, k)
  res = 0; 
  for i = 1:6
    xx = ((x(i)).^k)*w(i);
    res = res + xx;
  endfor
end

%Выборочная дисперсия
function res = v_disp(x, w)
  a = v_moment(x, w, 2);
  b = v_sred(x, w);
  res = a - b*b;
end

%Выборочное среднее квадратическое отклонение
function res = v_sredkotk(x, w)
  res = sqrt(v_disp(x, w));
end

%Выборочная мода
function res = v_moda(N)
  maxn = max(N);
  for i = 1:6
    if maxn == N(i)
      res = i-1;   
    endif
  endfor
end

%Выборочная медиана
function res = v_mediana(S)
    for i = 1:6
      if S(i) > 0.5
        res = i-1;
        break
      endif
    endfor
end

%Выборочный центральный момент к-ого порядка
function res = v_cmoment(x, w, k)
  res = 0; 
  a = v_sred(x, w);
  for i = 1:6
    xx = ((x(i) - a).^k)*w(i);
    res = res + xx;
  endfor
end

%Выборочный коэффициент асимметрии 
function res = v_kasim(x, w)
  a = v_cmoment(x, w, 3);
  b = v_sredkotk(x, w);
  res = a/(b.^3);
end

%Выборочный коэффициент эксцесса
function res = v_kex(x, w)
  a = v_cmoment(x, w, 4);
  b = v_sredkotk(x, w);
  res = a/(b.^4) - 3;
end

%Выборочное среднее для распределения Пуассона
xx = v_sred(x, w);
%Выборочная дисперсия для распределения Пуассона
d = v_disp(x, w);
%Выборочное среднее квадратическое отклонение распределения Пуассона
s = v_sredkotk(x, w);
%Выборочный коэффициент асимметрии для распределения Пуассона
a = v_kasim(x, w);
%Выборочный коэффициент эксцесса для распределения Пуассона
e = v_kex(x, w);

disp(sprintf('X =%.5f',xx))
disp(sprintf('D =%.5f',d))
disp(sprintf('S =%.5f',s))
%Выборочная мода для распределения Пуассона
MODA = v_moda(N)
%Выборочная медиана для распределения Пуассона
MEDIANA = v_mediana(S)
disp(sprintf('A =%.5f',a))
disp(sprintf('E =%.5f',e))


