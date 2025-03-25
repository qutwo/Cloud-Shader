
using UnityEditor.Experimental.GraphView;
using UnityEngine;


public class cloud : MonoBehaviour
{
    [SerializeField] Material mat;
    [SerializeField] Transform box;
    [SerializeField] ComputeShader genratorCompute;
    [SerializeField] RenderTexture noise;

    private void Start()
    {
        noise = new(1024, 1024, 1024);
        noise.enableRandomWrite = true;
        noise.Create();

        genratorCompute.SetTexture(0, "Result", noise);
        genratorCompute.Dispatch(0, noise.width / 8, noise.height / 8, 1);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture.active = destination;
        
        Vector4 rot_Cube1 = new Vector4(box.rotation.x,box.rotation.y,box.rotation.z,box.rotation.w);
        
        Vector4 rot_Cam = new Vector4(transform.rotation.x,transform.rotation.y,transform.rotation.z,transform.rotation.w);
        mat.SetVector("Quaternion_Cam", rot_Cam);
        mat.SetVector("Quaternion_Cube", rot_Cube1);
        mat.SetVector("Pos", box.position);
        mat.SetVector("Size", box.localScale);
        mat.SetTexture("_NoiseTexur" ,noise);
        
        
       
        //Debug.Log(rot_Cube);
        
        
        Graphics.Blit(source, destination, mat);
    }

}
