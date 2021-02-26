pkg load statistics
format long

p = 0.26;
A = geornd(p, 1, 200);
A_sort = sort(A);

%Запись массива в файл
f=fopen('geometric.txt','wt');
for i=1:200
  fprintf(f,'%d\t',A_sort(i));
end
fclose(f);

%Массив данных геометрического распределения 
f=fopen('geom.txt','rt');
for i=1:200
  A(i) = fscanf(f,'%d\t',1);
end
fclose(f);
A

%Полигон относительных частот для геометрического распределения
N = [50,40,27,23,18,18,7,4,2,0,4,3,1,2,1]; %Массив значений ni
x = [0:14];
w = N/200;
P = [0.26,0.1924,0.14238,0.10536,0.07797,0.05769,0.04269,0.03159,0.02338,0.0173,0.0128,0.00947,0.00701,0.00519,0.00384];
plot(x, w, 's-*', x, P, 'r-*')
grid on
grid minor

%Эмпирическая функция распределения геометрического распределения
S = [0.25,0.45,0.585,0.7,0.79,0.88,0.915,0.935,0.945,0.945,0.965,0.98,0.985,0.995,1];
figure
stairs(x, S)
grid on
grid minor

%Выборочное среднее
function res = v_sred(x, w)
  res = 0;
  for i = 1:15
    xx = x(i)*w(i);
    res = res + xx;
  endfor
end

%Выборочный момент к-ого порядка
function res = v_moment(x, w, k)
  res = 0; 
  for i = 1:15
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
  for i = 1:15
    if maxn == N(i)
      res = i-1;   
    endif
  endfor
end

%Выборочная медиана
function res = v_mediana(S)
    for i = 1:15
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
  for i = 1:15
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

%Выборочное среднее для геометрического распределения
xx = v_sred(x, w);
%Выборочная дисперсия для геометрического распределения 
d = v_disp(x, w);
%Выборочное среднее квадратическое отклонение для геометрического распределения
s = v_sredkotk(x, w);
%Выборочный коэффициент асимметрии для геометрического распределения 
a = v_kasim(x, w);
%Выборочный коэффициент эксцесса для геометрического распределения
e = v_kex(x, w);

disp(sprintf('X =%.5f',xx))
disp(sprintf('D =%.5f',d))
disp(sprintf('S =%.5f',s))
%Выборочная мода для геометрического распределения
MODA = v_moda(N)
%Выборочная медиана для геометрического распределения
MEDIANA = v_mediana(S)
disp(sprintf('A =%.5f',a))
disp(sprintf('E =%.5f',e))