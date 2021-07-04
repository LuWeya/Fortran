#include<iostream>
#include<vector>
using namespace std;
void dijkstra(const int &beg,//出发点
              const vector<vector<int> > &adjmap,//邻接矩阵，通过传引用避免拷贝
              vector<int> &dist,//出发点到各点的最短路径长度
              vector<int> &path)//路径上到达该点的前一个点
//负边被认作不联通
//福利：这个函数没有用任何全局量，可以直接复制！
{
    const int &NODE=adjmap.size();//用邻接矩阵的大小传递顶点个数，减少参数传递
    dist.assign(NODE,-1);//初始化距离为未知
    path.assign(NODE,-1);//初始化路径为未知
    vector<bool> flag(NODE,0);//标志数组，判断是否处理过
    dist[beg]=0;//出发点到自身路径长度为0
    while(1)
    {
        int v=-1;//初始化为未知
        for(int i=0; i!=NODE; ++i)
            if(!flag[i]&&dist[i]>=0)//寻找未被处理过且
                if(v<0||dist[i]<dist[v])//距离最小的点
                    v=i;
        if(v<0)return;//所有联通的点都被处理过
        flag[v]=1;//标记
        for(int i=0; i!=NODE; ++i)
            if(adjmap[v][i]>=0)//有联通路径且
                if(dist[i]<0||dist[v]+adjmap[v][i]<dist[i])//不满足三角不等式
                {
                    dist[i]=dist[v]+adjmap[v][i];//更新
                    path[i]=v;//记录路径
                }
    }
}
int main()
{
    int n_num,e_num,beg;//含义见下
    cout<<"输入点数、边数、出发点：";
    cin>>n_num>>e_num>>beg;
    vector<vector<int> > adjmap(n_num,vector<int>(n_num,-1));//默认初始化邻接矩阵
    for(int i=0,p,q; i!=e_num; ++i)
    {
        cout<<"输入第"<<i+1<<"条边的起点、终点、长度（负值代表不联通）：";
        cin>>p>>q;
        cin>>adjmap[p][q];
    }
    vector<int> dist,path;//用于接收最短路径长度及路径各点
    dijkstra(beg,adjmap,dist,path);
    for(int i=0; i!=n_num; ++i)
    {
        cout<<beg<<"到"<<i<<"的最短距离为"<<dist[i]<<"，反向打印路径：";
        for(int w=i; path[w]>=0; w=path[w])
            cout<<w<<"<-";
        cout<<beg<<'\n';
    }
}