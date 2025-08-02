resource "aws_iam_user" "user_creation" {
    name = var.users[count.index]

    count = length(var.users)

}