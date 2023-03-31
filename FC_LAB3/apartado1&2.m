%{
%--------------- Repaso---------------
clear
n1=randn(1000);
m1 = mean2(n1);
s1 = std2(n1);
n2=randn(1000);
s_suma = std(n1+n2);
s_resta = std(n1-n2);

m2 = 5;
s2 = 2;
n3=(n1-m1)/s1;
n3=n3*s2+m2;

fprintf("mean: %f\nstd: %f\n", mean2(n3), std2(n3))
fprintf("std suma n2+n3: %f\n", std2(n2+n3))
fprintf("std suma n1+n3: %f\n", std2(n1+n3))


%--------------- 1 ---------------
%----------- a) -----------
clear
raw = imread("black.pgm");
R=raw(1:2:end,1:2:end);
B = raw(2:2:end, 2:2:end);
G1 = raw(1:2:end, 2:2:end);
G2 = raw(2:2:end, 1:2:end);

figure(1)
hist(double(G1(:)),500);

fprintf("R -> Media: %.2f, Desviacion: %.2f\n", mean2(R), std2(R));
fprintf("G1 -> Media: %.2f, Desviacion: %.2f\n", mean2(G1), std2(G1));
fprintf("G2 -> Media: %.2f, Desviacion: %.2f\n", mean2(G2), std2(G2));
fprintf("B -> Media: %.2f, Desviacion: %.2f\n", mean2(B), std2(B));


%----------- b) -----------
load ruido

E = zeros(11, 1);
S = zeros(11, 1);
T = zeros(11, 1);

for k = 1:11
    frame = ruido{k} - 128;
    E(k) = mean2(frame);
    S(k) = std2(frame);
    
    T(k) = 1/1000 * sqrt(2)^(k-1);
    if T(k)>1/30
        T(k) = 1/30;
    end
end

figure(2)
plot(E, T);

figure(3);
semilogx(E, S, 'rs')

H = [E.^0 E E.^2];
b = S.^2;
c = H\b;

e=(100:4000);

h = [e'.^0 e' e'.^2];
s = sqrt(h*c);

hold on;
semilogx(e, s, 'b')
hold off;

a = s'./e * 100;
figure(4)
plot(e, a)


ruido_800 = a(1,800);
ruido_3200 = a(1,3200);
%}
%--------------- 2 ---------------
clear

im = imread('color.jpg'); 
im = im2double(im);
figure(1);
imshow(im);

[x, y]=ginput(1); 
x = round(x); y = round(y);
R = im(y, x, 1); G = im(y, x, 2); B = im(y, x, 3);
div=[R G B]/mean([R G B]);

conv = [R G B]./div;

im(:, 751:1500, 1) = im(:, 751:1500, 1)./div(1);
im(:, 751:1500, 2) = im(:, 751:1500, 1)./div(2);
im(:, 751:1500, 3) = im(:, 751:1500, 1)./div(3);
figure(2)
imshow(im);