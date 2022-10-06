using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Measure : MonoBehaviour
{
    [Header("Arrows")]
    public GameObject arrowLeft;
    public GameObject arrowRight;

    [Range(0f, 2f)]
    public float arrowScale = 0.15f;
    [Range(0, 90)]
    public float arrowAngle = 0;
    public Color arrowColor;

    [Header("Text")]
    public Text textField;
    [Range(0, 0.1f)]
    public float textScale = 0.02f;
    public Color textColor = Color.white;

    [Header("Canvas")]
    public GameObject canvas;
    float distance;

    private void OnDrawGizmos()
    {
        MeasureStuff();
    }

    private void OnValidate()
    {
        MeasureStuff();
    }

    void MeasureStuff()
    {
        distance = Vector3.Distance(arrowLeft.transform.position, arrowRight.transform.position);
        textField.text = distance.ToString("N2") + "m";

        canvas.transform.position = LeapByDistance(arrowLeft.transform.position, arrowRight.transform.position, 0.5f);

        if (arrowLeft != null)
        {
            arrowLeft.GetComponent<SpriteRenderer>().color = arrowColor;
            arrowLeft.transform.localScale = new Vector3(arrowScale, arrowScale, arrowScale);
            arrowLeft.transform.localRotation = Quaternion.Euler(arrowAngle, 0, 0);
        }
        if (arrowRight != null)
        {
            arrowRight.GetComponent<SpriteRenderer>().color = arrowColor;
            arrowRight.transform.localScale = new Vector3(arrowScale, arrowScale, arrowScale);
            arrowRight.transform.localRotation = Quaternion.Euler(arrowAngle, 0, 0);
        }

        if(textField != null)
        {
            textField.color = textColor;
            textField.transform.localScale = new Vector3(textScale, textScale, 0);
        }
    }

    Vector3 LeapByDistance(Vector3 A, Vector3 B, float X)
    {
        Vector3 Pos = A + X * (B - A);

        return Pos;
    }
}
