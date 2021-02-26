pkg load statistics
format long

n = 19;
p = 0.26;
A = binornd(n, p, 1, 200);
A_sort = sort(A);

%Запись массива в файл
f=fopen('binomial.txt','wt');
for i=1:200
  fprintf(f,'%d\t',A_sort(i));
end
fclose(f);

%Массив данных биномиального распределения 
f=fopen('binom.txt','rt');
for i=1:200
  A(i) = fscanf(f,'%d\t',1);
end
fclose(f);
A

%Полигон относительных частот для биномиального распределения
N = [0,4,8,21,49,41,33,23,15,5,1]; %Массив значений ni
x = [0:10];
w = N/200;
P = [0.00328,0.02187,0.06916,0.13771,0.19353,0.20399,0.16724,0.10912,0.05751,0.02470,0.00868];
plot(x, w, 's-*',x,P,'r-*')
grid on
grid minor

%Эмпирическая функция распределения биномиального распределения
S = [0,0.02,0.06,0.165,0.41,0.615,0.78,0.895,0.97,0.995,1];
figure
stairs(x, S)
grid on
grid minor

%Выборочное среднее
function res = v_sred(x, w)
  res = 0;
  for i = 1:11
    xx = x(i)*w(i);
    res = res + xx;
  endfor
end

%Выборочный момент к-ого порядка
function res = v_moment(x, w, k)
  res = 0; 
  for i = 1:11
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
  for i = 1:11
    if maxn == N(i)
      res = i-1;   
    endif
  endfor
end

%Выборочная медиана
function res = v_mediana(S)
    for i = 1:11
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
  for i = 1:11
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

%Выборочное среднее для биномиального распределения
xx = v_sred(x, w);
%Выборочная дисперсия для биномиального распределения 
d = v_disp(x, w);
%Выборочное среднее квадратическое отклонение для биномиального распределения
s = v_sredkotk(x, w);
%Выборочный коэффициент асимметрии для биномиального распределения 
a = v_kasim(x, w);
%Выборочный коэффициент эксцесса для биномиального распределения
e = v_kex(x, w);

disp(sprintf('X =%.5f',xx))
disp(sprintf('D =%.5f',d))
disp(sprintf('S =%.5f',s))
%Выборочная мода для биномиального распределения
MODA = v_moda(N)
%Выборочная медиана для биномиального распределения
MEDIANA = v_mediana(S)
disp(sprintf('A =%.5f',a))
disp(sprintf('E =%.5f',e))
