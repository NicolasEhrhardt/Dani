
import numpy as np

class Grid:
    def __init__(self,n,nw):
        self.size=n
        self.tab=np.zeros((n,n))
        self.free=[(i,j) for i in range(0,n) for j in range(0,n)]
        self.occup=[]
        self.nwin=nw
    def play(self,i,j,pl):
        self.tab[i,j]=pl
        self.free.remove((i,j))
        self.occup.append((i,j))

    def get(self,i,j):
        if (i<self.size) and (i>-1) and (j<self.size) and (j>-1):
            return self.tab[i,j]
        return 0

    def checkDir(self,c,d):
        x,y=c
        px,py=d
        u = 0
        for i in range(self.nwin):
            u +=  self.get(x+i*px, y+i*py)        
        return abs(u)>=self.nwin
            
    def isEnd(self):
        if len(self.free)==0: return True
        return False
        
    def hasWin(self):
        for c in self.occup:
            win=self.checkDir(c,(0,1)) or self.checkDir(c,(1,0)) or self.checkDir(c,(1,1)) or self.checkDir(c,(-1,1))
            if (win):
                print c
                return self.get(c[0],c[1])
        return 0
    
    def toStr(self):
        return "\n".join([" ".join(r) for r in self.tab])
    

def playRandom(world,pl):
    nxt=np.random.randint(len(world.free))
    return world.free[nxt]
    
            
    
class Game:
    def __init__(self,n,nw,player1,player2):
        self.world=Grid(n,nw)
        self.player1=player1
        self.player2=player2
        


    def play(self):
        pl=1
        histo=list()
        while(not (self.world.isEnd()) and not self.world.hasWin()):
            if (pl==1):
                nxt=self.player1(self.world,1)
            else:
                nxt=self.player2(self.world,-1)
            self.world.play(nxt[0],nxt[1],pl)
            pl=pl*-1
            histo.append(nxt)
            print self.world.tab
        print self.world.hasWin()
        return histo
    
            
    
if __name__== "__main__":
    g=Game(5,3,playRandom,playRandom)
    print g.play()
