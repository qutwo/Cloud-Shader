using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoiseGenrator : MonoBehaviour
{
    [SerializeField] ComputeShader genratorCompute;
    [SerializeField] RenderTexture noise;
    // Start is called before the first frame update
    void Start()
    {
        noise = new(1024, 1024, 1);
        noise.enableRandomWrite = true;
        noise.Create();

        genratorCompute.SetTexture(0, "Result", noise);
        genratorCompute.Dispatch(0, noise.width / 8, noise.height / 8, 1);
    }


}
