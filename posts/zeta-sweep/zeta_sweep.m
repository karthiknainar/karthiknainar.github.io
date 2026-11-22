clear all
clc
close all
A         = [0 1; 0 0];
B        = [0; 1];
C        = [1 0];
D         = 0;
wn      = 3;
zetas  = [0.3 0.8 1.0 1.2];
figure;
hold on;
for i  = 1:numel(zetas)
    zeta = zetas(i);
    p =  roots([1 2*zeta*wn wn^2])
    K  = acker(A,B,p);
    N = K(1);
    sys_cl = ss(A - B*K, B*N, C, D);
    info = stepinfo(sys_cl);            % measures overshoot, settling time, etc.
    fprintf('zeta = %.1f | K = [%.2f %.2f] | OS = %5.1f %% | Ts = %.2f s\n', ...
        zeta, K(1), K(2), info.Overshoot, info.SettlingTime);
    step(sys_cl);
end

legend('\zeta = 0.3', '\zeta = 0.8','\zeta = 1.0', '\zeta = 1.2');
grid on; title('Step response vs damping ratio');
exportgraphics(gcf, 'zetasweep.pdf', 'ContentType', 'vector');
zetas = [0.5 0.707 0.8 1 1.2];
OS = exp(-pi*zetas./sqrt(1-zetas.^2)) * 100;
OS(zetas>=1) = 0;
table(zetas', OS', 'VariableNames', {'zeta','OS_percent'})
% figure
% plot(zetas,OS)