
using UnityEngine;


public class SceneRaymarch : MonoBehaviour
{
    [SerializeField] Material mat;
    [SerializeField] Transform box1;
    [SerializeField] Transform box2;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture.active = destination;
        
        Vector4 rot_Cube1 = new Vector4(box1.rotation.x,box1.rotation.y,box1.rotation.z,box1.rotation.w);
        Vector4 rot_Cube2 = new Vector4(box2.rotation.x,box2.rotation.y,box2.rotation.z,box2.rotation.w);
        Vector4 rot_Cam = new Vector4(transform.rotation.x,transform.rotation.y,transform.rotation.z,transform.rotation.w);
        mat.SetVector("Quaternion_Cam", rot_Cam);
        mat.SetVector("Quaternion_Cube1", rot_Cube1);
        mat.SetVector("Quaternion_Cub2", rot_Cube2);
        mat.SetVector("Pos1", box1.position);
        mat.SetVector("Pos2", box2.position);
        mat.SetVector("Size1", box1.localScale);
        mat.SetVector("Size2", box2.localScale);
        //Debug.Log(rot_Cube);
        
        
        Graphics.Blit(source, destination, mat);
    }

}
