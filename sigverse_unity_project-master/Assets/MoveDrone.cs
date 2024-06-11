using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveDrone : MonoBehaviour
{
    float moveSpeed = 15f;
    float rotationSpeed = 60f;
    float upVel = 0f;
    Rigidbody rb;
    Vector3 leftRotation = Vector3.zero;
    Vector3 rightRotation = Vector3.zero;
    Vector3 rotation = Vector3.zero;
    Vector3 movement = Vector3.zero;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        leftRotation = new Vector3 (0, -rotationSpeed, 0);
        rightRotation = new Vector3(0, rotationSpeed, 0);
    }

    // Update is called once per frame
    void Update()
    {
        // left/right
        movement.x = Input.GetAxis("Horizontal");

        // up/down
        upVel = Input.GetAxis("Jump") * 60f * 10f * Time.deltaTime;

        // forward/backward
        movement.z = Input.GetAxis("Vertical");

        movement *= Time.deltaTime;

        if (Input.GetKey(KeyCode.Q)) rotation = leftRotation;
        else if (Input.GetKey(KeyCode.E)) rotation = rightRotation;
        else rotation = Vector3.zero;

        Quaternion deltaRotation = Quaternion.Euler(rotation * Time.deltaTime);
        rb.MoveRotation(rb.rotation * deltaRotation);

        movement = movement.normalized;

        Move(movement);
        rb.velocity = new Vector3(rb.velocity.x, upVel, rb.velocity.z);
    }

    void Move(Vector3 direction)
    {
        direction = rb.rotation * direction;
        rb.MovePosition(rb.position + direction * moveSpeed * Time.deltaTime);
    }
}
