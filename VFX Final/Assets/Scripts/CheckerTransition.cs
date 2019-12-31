using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckerTransition : MonoBehaviour
{
    Renderer rend;
    float freq;
    public Shader shader1;
    public Shader shader2;
    bool transitionStartingBool;
    bool transitionEndingBool;
    bool waiting = true;
    public float fixedWaitingTime;
    float elapsedWaitingTime;
    float transStartTime;
    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();

    }

    // Update is called once per frame
    void Update()
    {

        if (waiting)
        {
            elapsedWaitingTime += Time.deltaTime;
            if (elapsedWaitingTime > fixedWaitingTime)
            {
                waiting = false;
                elapsedWaitingTime = 0;
                transitionStartingBool = true;
            }
        }
        else if (transitionStartingBool)
        {
            freq = Mathf.Pow(transStartTime, 4.0f);
            rend.material.SetFloat("_Frequency", freq);
            transStartTime += Time.deltaTime;
            if (freq > 100)
            {
                transitionStartingBool = false;
                transitionEndingBool = true;
                SwitchShader();
            }
        }
        else if (transitionEndingBool)
        {
            freq = Mathf.Pow(transStartTime, 4.0f);
            rend.material.SetFloat("_Frequency", freq);
            transStartTime -= Time.deltaTime;
            if (freq < 1)
            {
                transitionEndingBool = false;
                waiting = true;
            }
        }
    }

    void SwitchShader()
    {
        if (rend.material.shader == shader1)
        {
            rend.material.shader = shader2;
        }
        else
        {
            rend.material.shader = shader1;
        }
    }
}
