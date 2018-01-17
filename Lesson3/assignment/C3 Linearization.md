### 题目，求以下contract Z的继承线
contract O <br>
contract A is O<br>
contract B is O<br>
contract C is O<br>
contract K1 is A,B<br>
contract K2 is A,C<br>
contract Z is K1,K2<br>

### 答：

L(O) := [O]<br>
L(A) := [A]+merge(L(O),[0])<br>
        = [A]+merge([0],[0])<br>
      = [A,0]<br>
L(B) := [B]+merge(L(O),[0])<br>
      = [B]+merge([0],[0])<br>
      = [B,0]<br>
L(C) := [C]+merge(L(O),[0])<br>
      = [C]+merge([0],[0])<br>
      = [C,0]<br>
L(K1):= [K1]+merge(L(A),L(B),[A,B])<br>
      = [K1]+merge([A,0],[B,0],[A,B])<br>
      = [K1,A]+merge([0],[B,0],[B])<br>
      = [K1,A,B]+merge([0],[0])<br>
      = [K1,A,B,0]<br>
L(K1):= [K2]+merge(L(A),L(C),[A,C])<br>
      = [K2]+merge([A,0],[C,0],[A,C])<br>
      = [K2,A]+merge([0],[C,0],[C])<br>
      = [K2,A,C]+merge([0],[0])<br>
      = [K2,A,C,0]<br>
L(Z): = [Z]+merge(L(K1),L(K2),[K1,K2])<br>
      = [Z]+merge([K1,A,B,0],[K2,A,C,0],[K1,K2])<br>
      = [Z,K1]+merge([A,B,0],[K2,A,C,0],[K2])<br>
      = [Z,K1,K2]+merge([A,B,0],[A,C,0])<br>
      = [Z,K1,K2,A]+merge([B,0],[C,0])<br>
      = [Z,K1,K2,A,B]+merge([0],[C,0])<br>
      = [Z,K1,K2,A,B,C]+merge([0],[0])<br>
      = [Z,K1,K2,A,B,C,0]<br>




      
