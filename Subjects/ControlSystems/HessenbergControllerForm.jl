using LinearAlgebra

A = [0.7665 0.1665 0.9047 0.4540 0.5007
     0.4777 0.4865 0.5045 0.2661 0.3841
     0.2378 0.8977 0.5163 0.0907 0.2771
     0.2749 0.9092 0.3190 0.9478 0.9138
     0.3593 0.0606 0.9866 0.0737 0.5297]

B = [0.4644 0.8278
     0.9410 0.1254
     0.0501 0.0159
     0.7615 0.6885
     0.7702 0.8682]

n = size(A, 1)
QR1 = qr(B)
B = QR1.R
A1 = QR1.Q'*A*QR1.Q
n1 = rank(B)
n2 = 1
for i=1:n
    global n1, n2, A1, QR1
    println(i)
    if n1 == n
        break
    end
    B1 = A1[n1+1:end,n2:n1] 
    QR1 = qr(B1)
    Q = [I(n1) zeros(n1, n-n1);
        zeros(n-n1, n1) QR1.Q']
    A1 = Q*A1*Q'
    n2 = n1
    n1 = n1 + rank(QR1.R)
end