%A script to test if 2d Hopfield network can recognize letter of alphabet



function [] = hopletter_recognition()

% close all

[X,~] = prprob;
%for i=1:10
%    figure;
%    plotchar(X(:,i))
%end
%Values must be +1 or -1
X(X==0)=-1;
%-------------------------------------------------------------------------

%Attractors of the Hopfield network
% w = reshape(X(:,1), 5, 7)';
% imshow(w)

w = X(:,1)';
o = X(:,2)';
j = X(:,3)';
c = X(:,4)';
i = X(:,5)';
e = X(:,6)';
h = X(:,7)';
k = X(:,8)';
u = X(:,9)';
b = X(:,10)';
r = X(:,11)';
s = X(:,12)';
A = X(:,13)';
B = X(:,14)';
C = X(:,15)';
D = X(:,16)';
E = X(:,17)';
F = X(:,18)';
G = X(:,19)';
H = X(:,20)';
I = X(:,21)';
J = X(:,22)';
K = X(:,23)';
L = X(:,24)';
M = X(:,25)';
U = [w;o;j;c;i;e;h;k;u;b;r;s;A;B;C;D;E;F;G;H;I;J;K;L;M]';

error_list = zeros(1,25);

for num = 1:25
    num_letters = num;

    
    T = U(:,1:num_letters);

    %Create network
    net = newhop(T);


    %Check if digits are attractors
    [Y,~,~] = sim(net,num_letters,[],T);
    Y = Y';

    figure;

    subplot(num_letters,3,1);


    for i = 1:num_letters
        letter = Y(i,:);
        letter = reshape(letter,5,7)'; 

        subplot(num_letters,3,((i-1)*3)+1);
        imshow(letter)
        if i == 1
            title('Attractors')
        end
        hold on
    end
    % Add noise - randmonly flip 3 pixels
    % as pixels are chosen randomly and the task does not mention
    % that they have to be different, they might be the same
    % in that case pixel is inverted twice i.e. stays the same.
    % in the unlikely event of choosing the same pixel 3 times, only this
    % pixel will be inverted

    %choose pixels to flip
    [dim, N] = size(X);
    R = round(unifrnd(0,35,3,N));
    %flip pixels
    Xn = X;
    for i=1:N;
        for j=1:dim
            if any(j==R(:,i))
                Xn(j,i) = -X(j,i);
            else
                Xn(j,i) = X(j,i);
            end
        end
    end

    %Show noisy digits:

    subplot(num_letters,3,2);

    for i = 1:num_letters
    letter = Xn(:,i);
    letter = reshape(letter,5,7)';
    subplot(num_letters,3,((i-1)*3)+2);
    imshow(letter)
    if i == 1
        title('Noisy digits')
    end
    hold on
    end

    %------------------------------------------------------------------------

    %See if the network can correct the corrupted digits 


    num_steps = 20;

    Tn = Xn(:,1:num_letters);
    [Yn,~,~] = sim(net,{num_letters num_steps},{},Tn);
    Yn = Yn{1,num_steps};
    Yn = Yn';
    subplot(num_letters,3,2);
    [dim1, dim2] = size(Yn);
    for i = 1:dim2
        for j =1:dim1
            if Yn(j,i) > 0
                Yn(j,i) = 1;
            else
                Yn(j,i) = -1;
            end
        end
    end

    for i = 1:num_letters
        letter = Yn(i,:);
        letter = reshape(letter,5,7)'; 

        subplot(num_letters,3,((i-1)*3)+1);
        imshow(letter)
    if i == 1
        title('Reconstructed noisy digits')
    end
    hold on

    end
    
    error = sum(sum(abs((Yn-Y)/2)));
    error_list(num) = error;
end

error_list
figure;
plot(1:length(error_list), error_list)
