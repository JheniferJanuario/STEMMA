namespace STEMMA.Domain.Cadastro.Entities;

public class Tutor
{
    public Guid Id { get; private set; }

    public string Nome { get; private set; }

    public string CPF { get; private set; }

    public string Email { get; private set; }
    public string Senha { get; private set; }

    public DateTime DataCriacao { get; private set; }

    public List<Pet> Pets { get; private set; }

    protected Tutor() { }

    public Tutor(
    string nome,
    string cpf,
    string email,
    string senha)
    {
        Validar(nome, cpf, email, senha);

        Id = Guid.NewGuid();
        Nome = nome;
        CPF = cpf;
        Email = email;
        Senha = senha;
        DataCriacao = DateTime.UtcNow;
        Pets = new List<Pet>();
    }

    public void AlterarNome(string nome, string cpf, string email)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception("O nome do tutor é obrigatório.");

        if (string.IsNullOrWhiteSpace(cpf))
            throw new Exception("O CPF é obrigatório.");

        if (string.IsNullOrWhiteSpace(email))
            throw new Exception("O email é obrigatório.");

        Nome = nome;
        CPF = cpf;
        Email = email;
    }

    private void Validar(string nome, string cpf, string email, string senha)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception("O nome do tutor é obrigatório.");

        if (string.IsNullOrWhiteSpace(cpf))
            throw new Exception("O CPF é obrigatório.");

        if (string.IsNullOrWhiteSpace(email))
            throw new Exception("O email é obrigatório.");

        if (string.IsNullOrWhiteSpace(senha))
            throw new Exception("A senha é obrigatória.");

        if (senha.Length < 6)
            throw new Exception("A senha deve possuir no mínimo 6 caracteres.");
    }
}