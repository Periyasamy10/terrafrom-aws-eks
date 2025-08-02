# resource "aws_iam_user" "user_creation" {
#     name = var.users[count.index]

#     count = length(var.users)

# }

resource "aws_iam_user" "user_creation" {
    name = each.value

    for_each = toset(var.users)

}



