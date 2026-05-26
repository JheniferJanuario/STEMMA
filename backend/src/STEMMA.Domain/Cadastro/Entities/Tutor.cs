namespace STEMMA.Domain.Cadastro.Entities;

public class Tutor
{
    public Guid Id { get; private set; }

    public string Nome { get; private set; }

    public string CPF { get; private set; }

    public string Email { get; private set; }

    public DateTime DataCriacao { get; private set; }

    public List<Pet> Pets { get; private set; }

    protected Tutor() { }

    public Tutor(string nome, string cpf, string email)
    {
        Validar(nome, cpf, email);

        Id = Guid.NewGuid();
        Nome = nome;
        CPF = cpf;
        Email = email;
        DataCriacao = DateTime.UtcNow;
        Pets = new List<Pet>();
    }

    public void AlterarNome(string nome)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception("O nome do tutor é obrigatório.");

        Nome = nome;
    }

    private void Validar(string nome, string cpf, string email)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception("O nome do tutor é obrigatório.");

        if (string.IsNullOrWhiteSpace(cpf))
            throw new Exception("O CPF é obrigatório.");

        if (string.IsNullOrWhiteSpace(email))
            throw new Exception("O email é obrigatório.");
    }
}